var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();

var options = SurrealDbOptions
  .Create()
  .WithEndpoint("http://database:8000")
  .WithNamespace("medvedi_stezka")
  .WithDatabase("medvedi_stezka")
  .WithUsername("root")
  .WithPassword("root")
  .Build();

builder.Services.AddSurreal(options);

var app = builder.Build();

// Configure the HTTP request pipeline.

app.UseAuthorization();

app.MapControllers();

app.Run();
