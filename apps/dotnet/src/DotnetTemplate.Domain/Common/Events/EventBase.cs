namespace DotnetTemplate.Domain.Common.Events;

public abstract class EventBase : IEvent
{
    public Guid EventId { get; init; } = Guid.CreateVersion7();
    public string EventType => GetType().Name;
}
