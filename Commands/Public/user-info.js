const { SlashCommandBuilder } = require("discord.js");
const { EmbedBuilder } = require("discord.js");

module.exports = {
  data: new SlashCommandBuilder()
    .setName("whois")
    .setDescription("Shows basic user information")
    .addUserOption((option) =>
      option
        .setName("user")
        .setDescription("the user you want to get info on")
        .setRequired(false)
    ),
  async execute(interaction) {
    const user = interaction.options.getUser("user") || interaction.user;
    const member = await interaction.guild.members.fetch(user.id);
    const icon = user.displayAvatarURL();
    const tag = user.tag;

    const embed = new EmbedBuilder()
      .setColor("LuminousVividPink")
      .setAuthor({ name: tag, iconURL: icon })
      .setThumbnail(icon)
      .addFields({ name: "Member", value: `${user}`, inline: false })
      .addFields({
        name: "Roles",
        value: `${member.roles.cache.map((r) => r).join(" ")}`,
        inline: false,
      })
      .addFields({
        name: "Joined Server",
        value: `<t:${parseInt(user.joinedAt / 1000)}:R>`,
        inline: true,
      })
      .addFields({
        name: "Joined Discord",
        value: `<t:${parseInt(user.createdAt / 1000)}:R>`,
        inline: true,
      })
      .setFooter({ text: `UserID: ${user.id}` })
      .setTimestamp();

    await interaction.reply({ embeds: [embed] });
  },
};
