using System.ComponentModel.DataAnnotations;

namespace MedvediStezkaAPI.Models
{
    public record OrganizationCreate
    {
        [Required]
        public required string Name { get; set; }
    }
}
