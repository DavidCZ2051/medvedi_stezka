using MedvediStezkaAPI.Models;
using MedvediStezkaAPI.Services;
using Microsoft.AspNetCore.Mvc;

namespace MedvediStezkaAPI.Controllers
{
    [ApiController]
    public class UserController(UserService userService) : ControllerBase
    {
        private readonly UserService _userService = userService;

        [HttpPost]
        [Route("/users")]
        public async Task<IActionResult> CreateUser([FromBody] Register register)
        {
            var (usernameTaken, user) = await _userService.CreateUser(register);
            return usernameTaken
                ? Problem("Username is already taken.", statusCode: 409)
                : CreatedAtAction("GetUser", user);
        }

        [HttpGet]
        [Route("/users/{id}")]
        public async Task<IActionResult> GetUser(string id)
        {
            var user = await _userService.GetUser(id);
            if (user == null)
            {
                return Problem("User not found.", statusCode: 404);
            }
            return Ok(user);
        }
    }
}
