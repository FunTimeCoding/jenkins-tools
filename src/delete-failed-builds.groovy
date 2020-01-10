def job = Jenkins.instance.getItem("example")
job.getBuilds().each {
    if (it.result == Result.FAILURE) {
        it.delete()
    }
}
