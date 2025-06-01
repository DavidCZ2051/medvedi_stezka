using Microsoft.AspNetCore.Authentication;
using Microsoft.Extensions.Options;
using SurrealDb.Net;
using System.Security.Claims;
using System.Text.Encodings.Web;

namespace MedvediStezkaAPI.Handlers
{
    public class TokenAuthenticationHandler(
        IOptionsMonitor<AuthenticationSchemeOptions> options,
        ILoggerFactory logger,
        UrlEncoder encoder,
        ISurrealDbClient surrealDbClient
    ) : AuthenticationHandler<AuthenticationSchemeOptions>(options, logger, encoder)
    {
        private readonly ISurrealDbClient _db = surrealDbClient;

        protected override Task<AuthenticateResult> HandleAuthenticateAsync()
        {
            string? authorizationHeader = Request.Headers.Authorization;

            if (string.IsNullOrEmpty(authorizationHeader) || !authorizationHeader.StartsWith("Bearer "))
            {
                return Task.FromResult(AuthenticateResult.NoResult());
            }

            string token = authorizationHeader["Bearer ".Length..].Trim();

            if (!ValidateToken(token, out var claims))
            {
                return Task.FromResult(AuthenticateResult.Fail("Invalid Bearer Token"));
            }

            var identity = new ClaimsIdentity(claims, Scheme.Name);
            var principal = new ClaimsPrincipal(identity);
            var ticket = new AuthenticationTicket(principal, Scheme.Name);

            return Task.FromResult(AuthenticateResult.Success(ticket));
        }

        private bool ValidateToken(string token, out List<Claim> claims)
        {
            claims = [];

            string? userId = _db.Query($"SELECT VALUE record::id(user) AS userId FROM ONLY (SELECT * FROM logins) WHERE expired = false && token = {token} LIMIT 1;").GetAwaiter().GetResult().GetValue<string?>(0);

            if (userId != null)
            {
                claims.Add(new Claim(ClaimTypes.NameIdentifier, userId));
                return true;
            }

            return false;
        }
    }
}
