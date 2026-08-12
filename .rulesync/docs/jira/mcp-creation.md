# Creating a Ticket in JIRA via Atlassian MCP

1. **Get the cloud ID** -- Call `getAccessibleAtlassianResources` to retrieve the Atlassian cloud ID.
2. **Find the project** -- Call `getVisibleJiraProjects` with a `searchString` matching the project key (infer from the branch name, plan context, or ask the user). Confirm the project exists and note the available issue types.
3. **Pick the issue type** -- Default to **Story** for feature work, **Task** for non-feature work, **Bug** for bug fixes, **Spike** for investigation/research work. Ask the user if unclear.
4. **Build the Acceptance Criteria `taskList`** -- Convert each acceptance criterion into an ADF `taskItem` inside a `taskList`. Use a unique string for each `localId` (e.g., `ac-1`, `ac-2`, `ac-list`). Every item starts with `"state": "TODO"`. The `taskList` itself is reusable — step 5 wraps it in a doc envelope, step 6 (fallback) embeds it inline in the description.

   ```json
   {
     "type": "taskList",
     "content": [
       {
         "type": "taskItem",
         "content": [{ "type": "text", "text": "First criterion" }],
         "attrs": { "localId": "ac-1", "state": "TODO" }
       },
       {
         "type": "taskItem",
         "content": [{ "type": "text", "text": "Second criterion" }],
         "attrs": { "localId": "ac-2", "state": "TODO" }
       }
     ],
     "attrs": { "localId": "ac-list" }
   }
   ```

5. **Create the issue with AC in the dedicated field (preferred path)** -- Call `createJiraIssue` with:
   - `projectKey` from step 2
   - `issueTypeName` from step 3
   - `summary` -- A concise title (the Summary section's first sentence, shortened)
   - `description` -- The ticket description (all sections **except** Acceptance Criteria), markdown formatted
   - `additional_fields: { "customfield_12471": { "type": "doc", "version": 1, "content": [<taskList from step 4>] } }`

6. **If `customfield_12471` is rejected, fall back to inline AC in the description** -- Some issue types (notably **Spike** in the PAID project) don't expose `customfield_12471` on the create or edit screens. JIRA returns:

   ```text
   Field 'customfield_12471' cannot be set. It is not on the appropriate screen, or unknown.
   ```

   Retry the `createJiraIssue` call:

   - Same `projectKey`, `issueTypeName`, `summary`
   - Drop `additional_fields`
   - Send `contentFormat: "adf"` and `description` as a full ADF `doc` whose `content` array ends with an `## Acceptance Criteria` heading followed by the `taskList` from step 4 inline (same node, just embedded in the description body rather than the dedicated field)

   The user-visible result is the same — interactive checkboxes — just rendered inline at the bottom of the description.

7. **Return the link** -- Show the user the issue key and a clickable URL (e.g., `https://<site>.atlassian.net/browse/PROJ-123`).
