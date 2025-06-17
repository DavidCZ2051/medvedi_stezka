using System.ComponentModel.DataAnnotations;

namespace MedvediStezkaAPI.Models
{
    public record CompetitionCreate
    {
        [Required]
        [AllowedValues("district", "region", "nation")]
        public required string Type { get; set; }
        [Required]
        public required string SchoolYear { get; set; }
        [Required]
        public required string Location { get; set; }
    }
}
