<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="GenreAlbumTracks.aspx.cs" Inherits="SamplePages_GenreAlbumTracks" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <h1>Genre Album Tracks</h1>
    <%--inside a repeater you need a minimum of a ItemTemplate
        Other templates include HeaderTemplate, Footertemplate, AlternatingItemTemplate, SeparatorTemplate
        
        The outer repeater will display the first fields from the DTO Class which do not repeat,
        the outer repeater fets its data from an ODS
        
        The nested repeater will display the collection of the DTO file
        the nested repeater will get its datasource from the collection (List/Ienumuerable) from the DTO class(either a POCO or another DTO)
        
        This pattern repeats from all levels of your data set--%>

    <asp:Repeater ID="GenreAlbumTrackList" runat="server" DataSourceID="GenreAlbumTrackListODS" ItemType="Chinook.Data.DTOs.GenreDTO">
        <ItemTemplate>
            <h2>Genre: <%# Eval("genre") %></h2>
            <asp:Repeater ID="GenreAlbums" runat="server" DataSource='<%# Eval("albums") %>' ItemType="Chinook.Data.DTOs.AlbumDTO">
                <ItemTemplate>
                    <h4>Album: <%# string.Format("{0} ({1}) Tracks: {2}", Eval("title"), Eval("releaseyear"), Eval("numberoftracks")) %></h4><br />
                    <asp:ListView ID="AlbumTracks" runat="server" ItemType="Chinook.Data.POCOs.TrackPOCO" DataSource="<%# Item.tracks %>">
                        <LayoutTemplate>
                            <table>
                                <tr style="background-color: #ccc">
                                    <th>Song</th>
                                    <th>Length</th>
                                </tr>
                                <tr id="ItemPlaceholder" runat="server"></tr>
                            </table>
                        </LayoutTemplate>
                        <ItemTemplate>
                            <tr style="background-color: lightseagreen">
                                <td style="width:600px"><%# Item.song %></td>
                                <td> <%# Item.length %></td>
                            </tr>
                        </ItemTemplate>
                        <AlternatingItemTemplate>
                            <tr style="background-color: Highlight">
                                <td style="width:600px"><%# Item.song %></td>
                                <td> <%# Item.length %></td>
                            </tr>
                        </AlternatingItemTemplate>
                        <EmptyDataTemplate>
                            <tr>
                                <td colspan="2">No data available at this time</td>
                            </tr>
                        </EmptyDataTemplate>
                    </asp:ListView>


<%--                    <asp:GridView ID="AlbumTracks" runat="server" ItemType="Chinook.Data.POCOs.TrackPOCO" DataSource="<%# Item.tracks %>" AutoGenerateColumns="False" GridLines="None">
                        <Columns>
                            <asp:TemplateField HeaderText="Song">
                                <ItemTemplate>
                                    <asp:Label runat="server" Text="<%# Item.song %>"></asp:Label>
                                </ItemTemplate>                           
                                <HeaderStyle HorizontalAlign="Left"></HeaderStyle>
                                <ItemStyle HorizontalAlign="Left"></ItemStyle>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Length">
                                <ItemTemplate>
                                    <asp:Label ID="Label1" runat="server" Text="<%# Item.length %>"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Right"></ItemStyle>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>--%>


<%--                    <asp:Repeater ID="AlbumTracks" runat="server" DataSource="<%# Item.tracks %>" ItemType="Chinook.Data.POCOs.TrackPOCO">
                        <HeaderTemplate>
                            <table>
                                <tr>
                                    <th>Song</th>
                                    <th>Length</th>
                                </tr>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td style="width:600px">
                                    <%# Item.song %>
                                </td>
                                <td>
                                    <%# Item.length %>
                                </td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                            </table>
                        </FooterTemplate>
                    </asp:Repeater>--%>
                </ItemTemplate>
            <SeparatorTemplate>
                <hr style="height:3px;border:none;color:#000;background-color:#000;" />
            </SeparatorTemplate>
            </asp:Repeater>
        </ItemTemplate>
    </asp:Repeater>
    <asp:ObjectDataSource ID="GenreAlbumTrackListODS" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="Genre_GenreAlbumTracks" TypeName="ChinookSystem.BLL.GenreController"></asp:ObjectDataSource>
</asp:Content>

