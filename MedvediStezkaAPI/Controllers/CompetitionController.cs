using MedvediStezkaAPI.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MedvediStezkaAPI.Models;

namespace MedvediStezkaAPI.Controllers
{
    [ApiController]
    public class CompetitionController(CompetitionService competitionService) : ControllerBase
    {
        private readonly CompetitionService _competitionService = competitionService;

        [HttpGet]
        [Route("/competitions")]
        [Authorize]
        public async Task<IActionResult> GetCompetitions()
        {
            return Ok(await _competitionService.GetAllCompetitions());
        }

        [HttpPost]
        [Route("/competitions")]
        [Authorize]
        public async Task<IActionResult> CreateCompetition([FromBody] CompetitionCreate competitionData)
        {
            return Ok(await _competitionService.CreateCompetition(competitionData));
        }
    }
}
