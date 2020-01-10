Jenkins.instance.getAllItems(AbstractProject.class).each {job ->
    println job.fullName;
    job.getBuilds().each {build ->
        if (build.result == Result.FAILURE) {
            build.delete()
        }
    }
}
