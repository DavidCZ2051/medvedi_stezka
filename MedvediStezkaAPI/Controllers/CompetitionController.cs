using MedvediStezkaAPI.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

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
    }
}
