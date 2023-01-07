const {
  ChatInputCommandInteraction,
  SlashCommandBuilder,
  EmbedBuilder,
} = require("discord.js");

module.exports = {
  data: new SlashCommandBuilder()
    .setName("ping")
    .setDescription("responds with Pong"),

  /**
   *
   * @param {ChatInputCommandInteraction} interaction
   */

  execute(interaction) {
    interaction.reply({ content: "Pong!", ephemeral: true });
  },
};
