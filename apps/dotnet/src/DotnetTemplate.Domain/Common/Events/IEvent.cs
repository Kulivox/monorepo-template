namespace DotnetTemplate.Domain.Common.Events;

public interface IEvent
{
    public Guid EventId { get; init; }
    public string EventType {
        get;
    }
}
