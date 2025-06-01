using System.ComponentModel.DataAnnotations;

namespace MedvediStezkaAPI.Models
{
    public record Login
    {
        [Required]
        public required string Username { get; set; }
        [Required]
        public required string Password { get; set; }
        [Required]
        public required bool RememberMe { get; set; }
    }
}
