using SurrealDb.Net;
using MedvediStezkaAPI.Models;

namespace MedvediStezkaAPI.Services
{
    public class UserService(ISurrealDbClient db)
    {
        private readonly ISurrealDbClient _db = db;

        public async Task<(bool UsernameTaken, Dictionary<string, string>? User)> CreateUser(Register register)
        {
            // Check if the username already exists
            var response = await _db.Query(
                $"(SELECT VALUE count() FROM ONLY users WHERE username = {register.Username} LIMIT 1) > 0;"
            );

            if (response.GetValue<bool>(0)!)
            {
                return (true, null);
            }

            // Create the user
            string passwordHash = BCrypt.Net.BCrypt.EnhancedHashPassword(register.Password);

            response = await _db.Query(
                $$"""
                SELECT username, nickname, role, record::id(id) AS id FROM ONLY (INSERT INTO users {
                    username: {{register.Username}},
                    nickname: {{register.Nickname}},
                    password: {{passwordHash}},
                    role: {{register.Role}}
                }) LIMIT 1;
                """
            );
            var user = response.GetValue<Dictionary<string, string>>(0);

            return (false, user);
        }

        public async Task<Dictionary<string, string>?> GetUser(string id)
        {
            // TODO
            return null;
        }
    }
}
