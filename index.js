const { Client, GatewayIntentBits, Partials, Collection } = require("discord.js");
const { Guilds, GuildMembers, GuildMessages } = GatewayIntentBits
const { User, Message, GuildMember, ThreadMember } = Partials

const client = new Client({ 
    intents: [Guilds, GuildMembers, GuildMessages],
    Partials: [User, Message, GuildMember, ThreadMember]
});


const { loadEvents } = require("./Handlers/eventHandler")

client.config = require("./config.json");
client.events = new Collection();
client.commands = new Collection();
client.subCommands = new Collection();

loadEvents(client);


client.login(client.config.token)
.then(() => {
    console.log(`Client logged in as ${client.user.tag}`);
    client.user.setActivity(`with ${client.guilds.cache.size} guilds`);
})
.catch((err) => console.log(err));