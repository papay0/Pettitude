const admin = require('firebase-admin');
const functions = require('firebase-functions');
admin.initializeApp();
const db = admin.firestore();
db.settings({ timestampsInSnapshots: true });

const createUser = async (userId: String) => {
    await db
        .collection("Users")
        .add({
            userId: userId,
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
            animalClassifiedNumber: 0,
            animal: {
                animalType: {
                    "cat": 0,
                    "dog": 0,
                    "bird": 0
                }
            }
        });
};

// add directly under Stats and not add a new object?
const createStats = async () => {
    const stat = await db.collection("Stats").doc("global_stats").get();
    if (!stat.exists) {
        await db
            .collection("Stats")
            .doc("global_stats")
            .set({
                animalClassifiedNumber: 0,
                createdAt: admin.firestore.FieldValue.serverTimestamp(),
                updatedAt: admin.firestore.FieldValue.serverTimestamp(),
                animal: {
                    animalType: {
                        "cat": 0,
                        "dog": 0,
                        "bird": 0
                    }
                }
            });
    }
};

const initData = async (userId: String) => {
    await createUser(userId);
    await createStats();
};

const updateAnimalCountForUser = async (user, animalType) => {
    const animalTypeKey = "animal.animalType." + animalType;
    await db.runTransaction(async t => {
        const animalTypeCount = user.data().animal.animalType[animalType];
        await t.update(user.ref, {
            [animalTypeKey]: animalTypeCount + 1,
            updatedAt: admin.firestore.FieldValue.serverTimestamp()
        });
    });
};

const updateAnimalCountStats = async (animalType) => {
    const animalTypeKey = "animal.animalType." + animalType;
    const stat = await db.collection("Stats").doc("global_stats").get();
    if (stat.exists) {
        await db.runTransaction(async t => {
            const animalTypeCount = stat.data().animal.animalType[animalType];
            await t.update(stat.ref, {
                [animalTypeKey]: animalTypeCount + 1,
                updatedAt: admin.firestore.FieldValue.serverTimestamp()
            });
        });
    }
};

const updateAnimalClassifiedNumberForUser = async (users) => {
    await db.runTransaction(async t => {
        const user = users.docs[0];
        const animalClassifiedNumber = user.data().animalClassifiedNumber;
        await t.update(user.ref, {
            animalClassifiedNumber: animalClassifiedNumber + 1,
            updatedAt: admin.firestore.FieldValue.serverTimestamp()
        });
    });
};

const updateAnimalClassifiedNumberStats = async () => {
    const stat = await db.collection("Stats").doc("global_stats").get();
    if (stat.exists) {
        await db.runTransaction(async t => {
            const animalClassifiedNumber = stat.data().animalClassifiedNumber;
            await t.update(stat.ref, {
                animalClassifiedNumber: animalClassifiedNumber + 1,
                updatedAt: admin.firestore.FieldValue.serverTimestamp()
            });
        })
        return true;
    }
    return false;
};

// Creates a user if needed
exports.login = functions.https.onCall(async (data, context) => {
    const userId = data.userId;
    const user = await db.collection("Users").where("userId", "==", userId).get();
    let userCreated = false;
    if (user.empty) {
        await initData(userId);
        userCreated = true;
    }
    return {
        userCreated: userCreated,
        userLoggedIn: true
    };
});

exports.animalClassified = functions.https.onCall(async (data, context) => {
    const userId = data.userId;
    const animalType = data.animalType
    // const feelingDescription = data.feelingDescription
    const userRef = db.collection("Users").where("userId", "==", userId);
    const users = await userRef.get();
    let updated = false;
    if (!users.empty) {
        await updateAnimalClassifiedNumberForUser(users);
        if (await updateAnimalClassifiedNumberStats()) {
            updated = true;
        }
        await updateAnimalCountForUser(users.docs[0], animalType);
        await updateAnimalCountStats(animalType);
    }
    return { updated: updated };
})