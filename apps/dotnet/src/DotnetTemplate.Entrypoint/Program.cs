using System.Reflection;
using DotnetTemplate.Application;
using DotnetTemplate.Infrastructure;

namespace DotnetTemplate.Entrypoint;

public partial class Program
{
    public static void Main(string[] args)
    {
        var builder = WebApplication.CreateBuilder(args);

        // Add services to the container.

        builder.Configuration.AddJsonFile("appsettings.local.json", optional: true, reloadOnChange: true);
        builder.Configuration.AddEnvironmentVariables("");


        // Configure controllers discovery and default json converters
        builder.Services.ConfigureControllers();

        // Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi
        builder.Services.AddOpenApi();

        // If OpenAPI build time generator is running, we don't want to inject any services / start any workers
        // https://learn.microsoft.com/en-us/aspnet/core/fundamentals/openapi/aspnetcore-openapi?view=aspnetcore-9.0&tabs=visual-studio%2Cvisual-studio-code#customizing-run-time-behavior-during-build-time-document-generation
        if (Assembly.GetEntryAssembly()?.GetName().Name != "GetDocument.Insider")
        {
            builder.Services.AddApplicationServices(builder.Configuration);
            builder.Services.AddInfrastructureServices(builder.Configuration);
        }

        var app = builder.Build();

        // Configure the HTTP request pipeline.
        if (app.Environment.IsDevelopment())
        {
            app.MapOpenApi();
        }

        app.UseHttpsRedirection();
        app.UseAuthentication();
        app.UseAuthorization();


        app.Run();
    }
}
