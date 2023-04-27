const configuration = {
    extends: ['@commitlint/config-conventional'],
    plugins: [
        {
            rules: {
                "jira-id-empty": (message) => {
                    const jiraRegex = /(\w+-{1}\d+)/;
                    let is_valid_rule = true;
                    let error_message = "";
                    const jira_id = message.jira_id;

                    if (jira_id === "" | jira_id === null) {
                        is_valid_rule = false;
                        error_message = "jira ID may not be empty";
                    } else {
                        const jira_id_prefix = jira_id.split("-")[0];
                        const jira_id_suffix = jira_id.split("-")[1];

                        if (jira_id_prefix === "" || jira_id_suffix === "") {
                            is_valid_rule = false;
                            error_message = "jira ID prefix or suffix may not be empty";
                        } else if (!jiraRegex.test(jira_id)) {
                            is_valid_rule = false;
                            error_message = "jira ID is not valid. Correct example: C2V1-123";
                        }
                    }

                    return [
                        is_valid_rule,
                        error_message,
                    ];
                },
            },
        },
    ],
    parserPreset: {
        parserOpts: {
            headerPattern: /^(\w*)\((\w*)\)\/(.*): (.*)$/,
            headerCorrespondence: ["type", "scope", "jira_id", "subject"],
        }
    },
    rules: {
        "jira-id-empty": [2, "always"],
        "type-empty": [2, "never"],
        "scope-empty": [2, "never"],
        "subject-empty": [2, "never"],
    },
}

module.exports = configuration;