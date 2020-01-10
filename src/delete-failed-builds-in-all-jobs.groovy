Jenkins.instance.getAllItems(AbstractProject.class).each {job ->
    count = 0

    job.getBuilds().each {build ->
        if (build.result == Result.FAILURE) {
            count++
        }
    }

    println(job.fullName + " " + count)

    if (count > 1) {
        job.getBuilds().each {build ->
            if (build.result == Result.FAILURE) {
                build.delete()
            }
        }
    }
}
