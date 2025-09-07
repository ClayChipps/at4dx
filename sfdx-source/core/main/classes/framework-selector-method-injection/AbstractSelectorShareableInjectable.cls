public abstract class AbstractSelectorShareableInjectable
    extends AbstractSelectorMethodInjectable
    implements ISelectorMethodShareable
{
    public virtual List<SObject> selectQuery() {
        ISelectorShareableParameterable parameters = (ISelectorShareableParameterable) getParameters();

        if (parameters.getWithSharing()) {
            return new WithSharing().selectQuery(this);
        }

        return new WithoutSharing().selectQuery(this);
    }

    private with sharing class WithSharing {
        public List<SObject> selectQuery(ISelectorMethodShareable selectorMethod) {
            return selectorMethod.executeQuery();
        }
    }

    private without sharing class WithoutSharing {
        public List<Account> selectQuery(ISelectorMethodShareable selectorMethod) {
            return selectorMethod.executeQuery();
        }
    }
}
