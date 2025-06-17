using MedvediStezkaAPI.Models;
using MedvediStezkaAPI.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace MedvediStezkaAPI.Controllers
{
    [ApiController]
    public class AuthenticationController(AuthenticationService authenticationService) : ControllerBase
    {
        private readonly AuthenticationService _authenticationService = authenticationService;

        [HttpPost]
        [Route("/auth/login")]
        public async Task<IActionResult> Login([FromBody] Login login)
        {
            var (errorMessage, token) = await _authenticationService.Login(login);
            if (errorMessage != null)
            {
                return Unauthorized(new { error = errorMessage });
            }
            return Ok(new { token });
        }

        [HttpGet]
        [Route("/auth/validate")]
        [Authorize]
        public IActionResult ValidateToken()
        {
            return Ok();
        }
    }
}
