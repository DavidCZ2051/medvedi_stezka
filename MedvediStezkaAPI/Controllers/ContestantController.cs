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
    }
}
