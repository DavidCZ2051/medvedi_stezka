using JWT.Algorithms;
using JWT.Builder;
using MedvediStezkaAPI.Models;
using SurrealDb.Net;

namespace MedvediStezkaAPI.Services
{
    public class AuthenticationService(ISurrealDbClient db)
    {
        private readonly ISurrealDbClient _db = db;
        private const int TokenExpirationHours = 24;

        public async Task<(string? errorMessage, string? token)> Login(Login login)
        {
            var response = await _db.Query(
                $"SELECT VALUE [record::id(id), password, nickname] FROM ONLY users WHERE username = {login.Username};"
            );
            string[]? user = response.GetValue<string[]?>(0);

            if (user == null)
            {
                return ("Incorrect username", null);
            }

            if (!BCrypt.Net.BCrypt.EnhancedVerify(login.Password, user[1]))
            {
                return ("Incorrect password", null);
            }

            string userId = user[0];
            string nickname = user[2];

            long? tokenExpirationTime = null;
            if (!login.RememberMe)
            {
                tokenExpirationTime = DateTimeOffset.UtcNow.AddHours(TokenExpirationHours).ToUnixTimeSeconds();
            }

            string token = JwtBuilder.Create()
                .WithAlgorithm(new HMACSHA256Algorithm())
                .WithSecret(Environment.GetEnvironmentVariable("JWT_SECRET"))
                .AddClaim("exp", tokenExpirationTime)
                .AddClaim("iat", DateTimeOffset.UtcNow.ToUnixTimeSeconds())
                .AddClaim("userId", userId)
                .AddClaim("nickname", nickname)
                .Encode();

            await _db.Query(
                $$"""
                INSERT INTO logins {
                    expires: RETURN IF {{tokenExpirationTime}} = null { null } ELSE { time::from::secs({{tokenExpirationTime}}) },
                    token: {{token}},
                    user: type::thing("users", {{userId}})
                };
                """
            );

            return (null, token);
        }
    }
}
