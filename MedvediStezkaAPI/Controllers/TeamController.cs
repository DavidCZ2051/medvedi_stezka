using MedvediStezkaAPI.Models;
using MedvediStezkaAPI.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace MedvediStezkaAPI.Controllers
{
    [ApiController]
    public class TeamController(TeamService teamService) : ControllerBase
    {
        private readonly TeamService _teamService = teamService;

        [HttpGet]
        [Route("/competition/{competitionId}/teams")]
        [Authorize]
        public async Task<IActionResult> GetTeams(string competitionId)
        {
            return Ok(await _teamService.GetAllTeams(competitionId));
        }

        [HttpPost]
        [Route("/competition/{competitionId}/teams")]
        [Authorize]
        public async Task<IActionResult> CreateContestant(string competitionId, [FromBody] TeamCreate teamData)
        {
            return Ok(await _teamService.CreateTeam(competitionId, teamData));
        }
    }
}
