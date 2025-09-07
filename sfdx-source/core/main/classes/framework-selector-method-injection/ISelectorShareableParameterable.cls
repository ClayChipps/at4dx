public interface ISelectorShareableParameterable
    extends ISelectorMethodParameterable
{
    Boolean getWithSharing();
    ISelectorShareableParameterable withoutSharing();
}
