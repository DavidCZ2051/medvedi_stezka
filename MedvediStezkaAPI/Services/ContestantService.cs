using MedvediStezkaAPI.Models;
using SurrealDb.Net;

namespace MedvediStezkaAPI.Services
{
    public class ContestantService(ISurrealDbClient db)
    {
        private readonly ISurrealDbClient _db = db;

        public async Task<List<Contestant>> GetAllContestants()
        {
            var response = await _db.Query(
                $"SELECT record::id(id) AS id, birthYear, name FROM contestants;"
            );

            return response.GetValue<List<Contestant>>(0)!;
        }

        public async Task<Contestant> CreateContestant(ContestantCreate contestant)
        {
            var response = await _db.Query(
                $$"""
                 SELECT record::id(id) AS id, name, birthYear FROM ONLY (INSERT INTO contestants {
                    birthYear: {{contestant.BirthYear}},
                    name: {
                        first: {{contestant.Name.First}},
                        middle: {{(contestant.Name.Middle == "" ? null : contestant.Name.Middle)}},
                        last: {{contestant.Name.Last}}
                    }
                }) LIMIT 1;
                """
            );
            return response.GetValue<Contestant>(0)!;
        }
    }
}
