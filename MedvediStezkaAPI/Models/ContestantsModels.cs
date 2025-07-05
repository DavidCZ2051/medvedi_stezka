namespace MedvediStezkaAPI.Models
{
    public class Contestant
    {
        public string Id;
        public uint BirthYear;
    }

    public record Name
    {
        public required string First { get; set; }
        public string? Middle { get; set; }
        public required string Last { get; set; }
    }
}