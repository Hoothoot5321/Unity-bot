const {
  ChatInputCommandInteraction,
  SlashCommandBuilder,
  EmbedBuilder,
} = require("discord.js");

module.exports = {
  data: new SlashCommandBuilder()
    .setName("embed-test")
    .setDescription("test embeds"),

  execute(interaction) {
    const testEmbed = new EmbedBuilder()
      .setColor(0x0099ff)
      .setTitle("Leage Rank")
      .setAuthor({ name: "særen" });

    interaction.reply({ embeds: [testEmbed] });
  },
};
