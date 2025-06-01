using MedvediStezkaAPI.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace MedvediStezkaAPI.Controllers
{
    [ApiController]
    [Route("/")]
    public class HelloController(HelloService helloService) : ControllerBase
    {
        private readonly HelloService _helloService = helloService;

        [HttpGet]
        public IActionResult Get()
        {
            return Ok("Hello world!");
        }

        [HttpGet]
        [Route("/test")]
        [Authorize]
        public async Task<IActionResult> Test()
        {
            return Ok(await _helloService.HelloTest());
        }
    }
}
