using MedvediStezkaAPI.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MedvediStezkaAPI.Models;

namespace MedvediStezkaAPI.Controllers
{
    [ApiController]
    public class OrganizationController(OrganizationService organizationService) : ControllerBase
    {
        private readonly OrganizationService _organizationService = organizationService;

        [HttpGet]
        [Route("/organizations")]
        [Authorize]
        public async Task<IActionResult> GetOrganizations()
        {
            return Ok(await _organizationService.GetAllOrganizations());
        }

        [HttpPost]
        [Route("/organizations")]
        [Authorize]
        public async Task<IActionResult> CreateOrganization([FromBody] OrganizationCreate organizationData)
        {
            var result = await _organizationService.CreateOrganization(organizationData);
            
            if (result == null)
            {
                return Conflict("Organization with this name already exists.");
            }
            return Ok(result);
        }
    }
}
