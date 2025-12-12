# Repository Guidelines

## Project Structure & Module Organization
- Source code is split across Maven modules: `core/`, `services/`, `model/`, and `server-spi*` hold authentication, APIs, and service logic; `quarkus/` builds and packages the server; `distribution/` and `operator/` contain delivery artifacts; `themes/` holds UI assets; `docs/` stores contributor and user guides.
- Tests live primarily in `testsuite/integration-arquillian` (server integration/UI) and `quarkus/tests` (distribution checks); utilities for running local test servers sit in `testsuite/utils`.

## Build, Test, and Development Commands
- Use JDK 17 or 21 and the Maven wrapper: set `JAVA_HOME` accordingly.
- Fast sanity build (no tests): `./mvnw clean install -DskipTests`.
- Full build + suites (slow): `./mvnw clean install`.
- Build only the server distribution: `./mvnw -pl quarkus/deployment,quarkus/dist -am -DskipTests clean install` (artifacts in `quarkus/dist/target`).
- Run the dev server with live reload: `./mvnw -f quarkus/server/pom.xml compile quarkus:dev -Dkc.config.built=true -Dquarkus.args="start-dev"`.
- Format check/fix: `./mvnw spotless:check` then `./mvnw spotless:apply` if needed.

## Coding Style & Naming Conventions
- Follow existing module patterns and WildFly-style Java formatting (4-space indent, braces on new lines where already used).
- Keep package names lowercase and descriptive; class names are `PascalCase`; tests end with `*Test`.
- Avoid introducing new dependencies without discussion; reuse existing utilities.
- Keep changes scoped to the feature; avoid drive-by refactors.

## Testing Guidelines
- Prefer integration/functional tests near related code (`testsuite/integration-arquillian/tests/base` is the main suite); unit tests are reserved for small utility classes.
- Use Hamcrest `assertThat` matchers for readability; do not add new mocking frameworks.
- UI/browser tests default to HtmlUnit; override with `-Dbrowser=chrome` or `-Dbrowser=firefox` when running Maven tests.
- Start the lightweight test server when iterating on themes or flows: `cd testsuite/utils && mvn exec:java -Pkeycloak-server`.

## Commit & Pull Request Guidelines
- Open an issue and keep one feature per PR; squash to a single commit and rebase on `main` before submission.
- Commit message format: short summary, optional details, then `Closes #1234`. Sign off each commit (`git commit --signoff`) to satisfy DCO.
- Run `./mvnw spotless:check` and relevant tests before pushing; include documentation updates when behavior changes.
- PRs should link the issue, describe scope and testing performed, and avoid unrelated formatting changes. Monitor reviewer feedback and update promptly.

## Communication
- 默认使用简体中文回答问题和编写沟通说明，除非需求或上游文档必须使用英文。

## Current Focus
- 目前仅聚焦 VectorStory 主题开发，路径：`themes/src/main/resources/theme/vectorstory`。
