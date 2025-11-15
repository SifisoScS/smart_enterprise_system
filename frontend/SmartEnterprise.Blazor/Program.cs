using Microsoft.AspNetCore.Components.Web;
using Microsoft.AspNetCore.Components.WebAssembly.Hosting;
using SmartEnterprise.Blazor;
using SmartEnterprise.Blazor.Services;

var builder = WebAssemblyHostBuilder.CreateDefault(args);
builder.RootComponents.Add<App>("#app");
builder.RootComponents.Add<HeadOutlet>("head::after");

// Configure HTTP client for backend API
builder.Services.AddScoped(sp => new HttpClient 
{ 
    BaseAddress = new Uri("http://localhost:5001/api/") 
});

// Register application services
builder.Services.AddScoped<ApiService>();
builder.Services.AddScoped<AuthService>();

// Add logging
builder.Logging.SetMinimumLevel(LogLevel.Debug);

await builder.Build().RunAsync();