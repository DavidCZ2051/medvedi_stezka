using SurrealDb.Net;

namespace MedvediStezkaAPI.Services
{
    public class CompetitionService(ISurrealDbClient db)
    {
        private readonly ISurrealDbClient _db = db;

        public async Task<List<Dictionary<string, string>>> GetAllCompetitions()
        {
            var response = await _db.Query(
                $"SELECT location, schoolYear, type, record::id(id) AS id FROM competitions;"
            );
            return response.GetValue<List<Dictionary<string, string>>>(0)!;
        }
    }
}
