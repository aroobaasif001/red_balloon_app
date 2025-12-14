# Quick Debug Test

Run the app and check console logs for:

```
✅ Proof found for task: xxx, proofId: yyy
   Has images: true/false
```

If you see `Has images: false`, then the issue is confirmed - multiple proofs exist and the one with images has a different proofId.

## Manual Test
Can you check in Firebase Console:
1. Go to `task_proofs` collection
2. Filter by `taskId == 37FaZflVy8KKXZXm8G0l`
3. How many documents exist?
4. Which one has the `beforePhotoUrl` and `afterPhotoUrl`?
5. What is the `submittedAt` timestamp for the one with images?

This will confirm if multiple proofs exist.
