using MedvediStezkaAPI.Models;
using MedvediStezkaAPI.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace MedvediStezkaAPI.Controllers
{
    [ApiController]
    public class ContestantController(ContestantService contestantService) : ControllerBase
    {
        private readonly ContestantService _contestantService = contestantService;

        [HttpGet]
        [Route("/contestants")]
        [Authorize]
        public async Task<IActionResult> GetContestants()
        {
            return Ok(await _contestantService.GetAllContestants());
        }

        [HttpPost]
        [Route("/contestants")]
        [Authorize]
        public async Task<IActionResult> CreateContestant([FromBody] ContestantCreate contestantData)
        {
            return Ok(await _contestantService.CreateContestant(contestantData));
        }
    }
}
