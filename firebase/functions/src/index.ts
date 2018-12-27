const admin = require('firebase-admin');
const functions = require('firebase-functions');
admin.initializeApp();
const db = admin.firestore();

const createUser = async (userId: String) => {
    await db
        .collection("Users")
        .add({
            userId: userId,
            timestamp: admin.firestore.FieldValue.serverTimestamp()
        });
}

// Creates a user if needed
exports.login = functions.https.onCall(async (data, context) => {
    const userId = data.userId;
    const user = await db.collection("Users").where("userId", "==", userId).get();
    let userCreated = false;
    if (user.empty) {
        await createUser(userId);
        userCreated = true;
    }
    return {
        userCreated: userCreated,
        userLoggedIn: true
    };
})