const {
  ChatInputCommandInteraction,
  SlashCommandBuilder,
  EmbedBuilder,
} = require("discord.js");

module.exports = {
  data: new SlashCommandBuilder()
    .setName("pong")
    .setDescription("responds with Pring"),

  /**
   *
   * @param {ChatInputCommandInteraction} interaction
   */

  execute(interaction) {
    interaction.reply({ content: "Ping!", ephemeral: true });
  },
};
