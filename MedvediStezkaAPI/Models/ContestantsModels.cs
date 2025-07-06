using Dahomey.Cbor.Attributes;

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
}