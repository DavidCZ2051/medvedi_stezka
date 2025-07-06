using MedvediStezkaAPI.Models;
using SurrealDb.Net;

namespace MedvediStezkaAPI.Services
{
    public class TeamService(ISurrealDbClient db)
    {
        private readonly ISurrealDbClient _db = db;

        public async Task<List<Dictionary<string, string>>> GetAllTeams(string competitionId)
        {
            var response = await _db.Query(
                $""
            );

            return response.GetValue<List<Dictionary<string, string>>>(0)!;
        }

        public async Task<Dictionary<string, string>> CreateTeam(string competitionId, TeamCreate teamData)
        {
            var response = await _db.Query(
                $$"""
                 
                """
            );
            return response.GetValue<Dictionary<string, string>>(0)!;
        }
    }
}
