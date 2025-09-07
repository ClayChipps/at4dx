public abstract class AbstractSelectorShareableParameterable 
    implements ISelectorShareableParameterable 
{

    protected Boolean withSharing = true;

    public virtual Boolean getWithSharing() 
    {
        return this.withSharing;
    }

    public virtual ISelectorShareableParameterable withoutSharing()
    {
        this.withSharing = false;
        return this;
    }

    public abstract Boolean equals(Object obj);

    public abstract Integer hashCode();
}
