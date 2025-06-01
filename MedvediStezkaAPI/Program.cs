using Microsoft.AspNetCore.Authentication;
using MedvediStezkaAPI.Handlers;
using MedvediStezkaAPI.Services;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();

// Add SurrealDB client
builder.Services.AddSurreal(
    SurrealDbOptions
      .Create()
      .WithEndpoint("http://database:8000")
      .WithNamespace("medvedi_stezka")
      .WithDatabase("medvedi_stezka")
      .WithUsername(Environment.GetEnvironmentVariable("SURREAL_USER"))
      .WithPassword(Environment.GetEnvironmentVariable("SURREAL_PASS"))
      .Build()
    );

// Add Authentication, used with the [Authorize] attribute
builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = "Token";
    options.DefaultChallengeScheme = "Token";
})
.AddScheme<AuthenticationSchemeOptions, TokenAuthenticationHandler>("Token", null);

// Add services
builder.Services.AddScoped<HelloService>();
builder.Services.AddScoped<MedvediStezkaAPI.Services.AuthenticationService>();

var app = builder.Build();

// Configure the HTTP request pipeline.

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();
