using SurrealDb.Net;
using SurrealDb.Net.Models.Response;

namespace MedvediStezkaAPI.Services
{
    public class HelloService(ISurrealDbClient db)
    {
        private readonly ISurrealDbClient _db = db;

        public async Task<int> HelloTest()
        {
            SurrealDbResponse response = await _db.Query($"RETURN 1 + 1;");
            return response.FirstOk!.GetValue<int>();
        }
    }
}
