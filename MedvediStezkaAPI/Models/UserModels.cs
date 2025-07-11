﻿using System.ComponentModel.DataAnnotations;

namespace MedvediStezkaAPI.Models
{
    public record Register
    {
        [Required]
        public required string Username { get; set; }
        [Required]
        public required string Password { get; set; }
        [Required]
        public required string Nickname { get; set; }
    }
}
