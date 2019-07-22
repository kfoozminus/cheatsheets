
https://itnext.io/building-an-operator-for-kubernetes-with-kubebuilder-17cbd3f07761
https://www.godoc.org/sigs.k8s.io/controller-runtime/pkg

### Core principals of k8s:

The structure of Kubernetes APIs and Resources
API versioning semantics
Self-healing
Garbage Collection and Finalizers
Declarative vs Imperative APIs
Level-Based vs Edge-Base APIs
Resources vs Subresources

###

kubebuilder init --domain k8s.io --license apache2 --owner "The Kubernetes Authors"
kubebuilder create api --group mygroup --version v1beta1 --kind MyKind
minikube start
make install
make run




## Steps
- init
- create api
- define types.go
- add status subresource
```
// +kubebuilder:subresource:status
type SampleSource struct {
  // ...
}
```
- remove deployment - 1. remove +kubebuilder:rbac:deployment 2. deployment object 3. watch deployment
- edit Reconcile
- edit types_test.go




-----------------------------------------------------------------------v2


-------------------
Finally, we have the rest of the boilerplate that we’ve already discussed. As previously noted, we don’t need to change this, except to mark that we want a status subresource, so that we behave like built-in kubernetes types.

// +kubebuilder:object:root=true
// +kubebuilder:subresource:status

// CronJob is the Schema for the cronjobs API
type CronJob struct {
￼-------------------
logging works by attaching key-value pairs to a static message. We can pre-assign some pairs at the top of our reconcile method to have those attached to all log lines in this reconciler.



func (r *CronJobReconciler) Reconcile(req ctrl.Request) (ctrl.Result, error) {
    _ = context.Background()
    _ = r.Log.WithValues("cronjob", req.NamespacedName)

    // your logic here

    return ctrl.Result{}, nil
}
-------------------
Remember, status should be able to be reconstituted from the state of the world, so it’s generally not a good idea to read from the status of the root object. Instead, you should reconstruct it every run. That’s what we’ll do here.
-------------------
Notice how instead of using a format string, we use a fixed message, and attach key-value pairs with the extra information. This makes it easier to filter and query log lines.

￼

    log.V(1).Info("job count", "active jobs", len(activeJobs), "successful jobs", len(successfulJobs), "failed jobs", len(failedJobs))

-------------------
To specifically update the status subresource, we’ll use the Status part of the client, with the Update method.

The status subresource ignores changes to spec, so it’s less likely to conflict with any other updates, and can have separate permissions.

    if err := r.Status().Update(ctx, &cronJob); err != nil {
        log.Error(err, "unable to update CronJob status")
        return ctrl.Result{}, err
    }
-------------------
    scheduledResult := ctrl.Result{RequeueAfter: nextRun.Sub(r.Now())} // save this so we can re-use it elsewhere
    log = log.WithValues("now", r.Now(), "next run", nextRun)
-------------------
https://book.kubebuilder.io/cronjob-tutorial/controller-implementation.html#setup
Finally, we’ll update our setup. In order to allow our reconciler to quickly look up Jobs by their owner, we’ll need an index. We declare an index key that we can later use with the client as a pseudo-field name, and then describe how to extract the indexed value from the Job object. The indexer will automatically take care of namespaces for us, so we just have to extract the owner name if the Job has a CronJob owner.

Additionally, we’ll inform the manager that this controller owns some Jobs, so that it will automatically call Reconcile on the underlying CronJob when a Job changes, is deleted, etc.

var (
    jobOwnerKey = ".metadata.controller"
    apiGVStr    = batch.GroupVersion.String()
)

func (r *CronJobReconciler) SetupWithManager(mgr ctrl.Manager) error {
    // set up a real clock, since we're not in a test
    if r.Clock == nil {
        r.Clock = realClock{}
    }

    if err := mgr.GetFieldIndexer().IndexField(&kbatch.Job{}, jobOwnerKey, func(rawObj runtime.Object) []string {
        // grab the job object, extract the owner...
        job := rawObj.(*kbatch.Job)
        owner := metav1.GetControllerOf(job)
        if owner == nil {
            return nil
        }
        // ...make sure it's a CronJob...
        if owner.APIVersion != apiGVStr || owner.Kind != "CronJob" {
            return nil
        }

        // ...and if so, return it
        return []string{owner.Name}
    }); err != nil {
        return err
    }

    return ctrl.NewControllerManagedBy(mgr).
        For(&batch.CronJob{}).
        Owns(&kbatch.Job{}).
        Complete(r)
}
--------------------main.go

    if err = (&controllers.CronJobReconciler{
        Client: mgr.GetClient(),
        Log:    ctrl.Log.WithName("controllers").WithName("Captain"),
    }).SetupWithManager(mgr); err != nil {
        setupLog.Error(err, "unable to create controller", "controller", "Captain")
        os.Exit(1)
    }
    if err = (&batchv1.CronJob{}).SetupWebhookWithManager(mgr); err != nil {
        setupLog.Error(err, "unable to create webhook", "webhook", "Captain")
        os.Exit(1)
    }
    // +kubebuilder:scaffold:builder

----------------admission webhook
https://book.kubebuilder.io/cronjob-tutorial/webhook-implementation.html

---------------
https://book.kubebuilder.io/cronjob-tutorial/running.html
Note that if you have a webhook and want to deploy it locally, you need to ensure the certificates are in the right place.

---------------
