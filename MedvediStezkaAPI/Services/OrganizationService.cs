using MedvediStezkaAPI.Models;
using SurrealDb.Net;

namespace MedvediStezkaAPI.Services
{
    public class OrganizationService(ISurrealDbClient db)
    {
        private readonly ISurrealDbClient _db = db;

        public async Task<List<Dictionary<string, string>>> GetAllOrganizations()
        {
            var response = await _db.Query(
                $"SELECT name FROM organizations;"
            );
            return response.GetValue<List<Dictionary<string, string>>>(0)!;
        }

        public async Task<Dictionary<string, string>?> CreateOrganization(OrganizationCreate organizationData)
        {
            var response = await _db.Query(
                $"(SELECT VALUE count() FROM ONLY organizations WHERE name = {organizationData.Name} LIMIT 1) > 0;"
            );

            if (response.GetValue<bool>(0)!)
            {
                return null;
            }

            response = await _db.Query(
                $$"""
                 SELECT name FROM ONLY (INSERT INTO organizations {
                    name: {{organizationData.Name}}
                 }) LIMIT 1;
                """
            );

            return response.GetValue<Dictionary<string, string>>(0)!;
        }
    }
}
