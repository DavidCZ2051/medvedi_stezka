using Dahomey.Cbor.Attributes;
using MedvediStezkaAPI.Attributes;
using System.ComponentModel.DataAnnotations;

namespace MedvediStezkaAPI.Models
{
    public class Contestant
    {
        [CborProperty("id")]
        public required string Id { get; set; }
        [CborProperty("birthYear")]
        public int BirthYear { get; set; }
        [CborProperty("name")]
        public required Dictionary<string, string?> Name { get; set; }
    }

    public record ContestantCreate
    {
        [Required]
        public required uint BirthYear { get; set; }
        [Required]
        public required ContestantName Name { get; set; }
    }

    public record ContestantName
    {
        [Required]
        [NoSpaces]
        public required string First { get; set; }
        public string? Middle { get; set; }
        [Required]
        [NoSpaces]
        public required string Last { get; set; }
    }
}