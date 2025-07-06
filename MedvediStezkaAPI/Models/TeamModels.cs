using System.ComponentModel.DataAnnotations;

namespace MedvediStezkaAPI.Models
{
    public record TeamCreate
    {
        [Required]
        public required string OrganizationId { get; set; }
        [Required]
        [AllowedValues("M1", "F1", "M2", "F2", "M3", "F3", "M4", "F4", "M5", "F5")]
        public required string Category { get; set; }
        [Required]
        public required string[] MemberIds { get; set; }
    }
}
