# llnode-v8-tester

This repository track changes on V8 postmortem metadata. It uses GitHub Actions
to build V8 daily, and then compares the postmortem metadata present on that
build with previous results. If something changed, an issue is created. Every
V8 build is uploaded as GitHub Actions Artifacts.

In the future this workflow can include running llnode test suite against
latest d8 binaries.
