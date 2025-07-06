using System.ComponentModel.DataAnnotations;

namespace MedvediStezkaAPI.Attributes
{
    public class NoSpacesAttribute : ValidationAttribute
    {
        protected override ValidationResult? IsValid(object? value, ValidationContext validationContext)
        {
            var str = value as string;
            if (!string.IsNullOrEmpty(str) && str.Contains(' '))
            {
                return new ValidationResult($"{validationContext.DisplayName} cannot contain spaces.");
            }
            return ValidationResult.Success;
        }
    }
}
