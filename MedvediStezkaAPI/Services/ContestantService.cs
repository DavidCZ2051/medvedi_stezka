using MedvediStezkaAPI.Models;
using SurrealDb.Net;

namespace MedvediStezkaAPI.Services
{
    public class ContestantService(ISurrealDbClient db)
    {
        private readonly ISurrealDbClient _db = db;

        public async Task<List<Contestant>> GetAllContestants()
        {
            var response = await _db.RawQuery(
                $"SELECT record::id(id) AS id, birthYear, name FROM contestants;"
            );

            return response.GetValue<List<Contestant>>(0)!;
        }
    }
}
