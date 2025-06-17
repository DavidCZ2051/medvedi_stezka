using MedvediStezkaAPI.Models;
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

        public async Task<Dictionary<string, string>> CreateCompetition(CompetitionCreate competitionData)
        {
            var response = await _db.Query(
                $$"""
                 SELECT type, location, schoolYear, record::id(id) AS id FROM ONLY (INSERT INTO competitions {
                    type: {{competitionData.Type}},
                    location: {{competitionData.Location}},
                    schoolYear: {{competitionData.SchoolYear}}
                 }) LIMIT 1;
                """
            );
            return response.GetValue<Dictionary<string, string>>(0)!;
        }
    }
}
