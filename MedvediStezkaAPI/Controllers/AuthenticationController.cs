using MedvediStezkaAPI.Models;
using MedvediStezkaAPI.Services;
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
            var result = await _authenticationService.Login(login);
            if (result.errorMessage != null)
            {
                return Unauthorized(new { error = result.errorMessage });
            }
            return Ok(new { result.token });
        }
    }
}
