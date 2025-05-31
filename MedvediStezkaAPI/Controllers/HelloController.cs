using Microsoft.AspNetCore.Mvc;
using SurrealDb.Net;
using SurrealDb.Net.Models.Response;

namespace MedvediStezkaAPI.Controllers
{
    [ApiController]
    [Route("/")]
    public class HelloController(ISurrealDbClient db) : ControllerBase
    {
        private readonly ISurrealDbClient _db = db;

        [HttpGet]
        public IActionResult Get()
        {
            return Ok("Hello world!");
        }

        [HttpGet]
        [Route("/test")]
        public async Task<IActionResult> Test()
        {
            SurrealDbResponse response = await _db.Query($"RETURN 1 + 1;");
            if (response.FirstOk == null)
            {
                return BadRequest("No valid response from the query.");
            }
            int? data = response.FirstOk.GetValue<int>();
            if (data == null)
            {
                return BadRequest("No data returned from the query.");
            }
            return Ok(data);
        }
    }
}
